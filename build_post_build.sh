#!/bin/sh

set -e

echo '[Info] Run post_build script'

if [ -z "$branch" ]; then
  echo '[Error] $branch is empty. Nothing to do.'
  exit 1
fi

if [ -z "$commit" ]; then
  echo '[Error] $commit is empty. Nothing to do.'
  exit 1
fi

if [ -z "$image" ]; then
  echo '[Error] $image is empty. Nothing to do.'
  exit 1
fi


if [ -z "$tag" ]; then
  echo '[Warning] $tag is empty.'
  tags=()
else
  v1=${tag%.*.*}
  v2=${tag%.*}
  v3=${tag%[^0-9.]}
  v4=${tag%}
  echo "[Info] Version tags are $v1 $v2 $v3 $v4"
  tags=($v1 $v2 $v3 $v4)
fi

branch_as_tag=${branch//[\/]/_}
if [[ "$branch_as_tag" =~ ^[a-z0-9_]{1,100}$ ]]; then
    echo "[Info] Branch name is valid to be an image tag: $branch_as_tag"
    tags+=($branch_as_tag)
else
    echo '[Warning] Branch name cannot be a valid image tag'
fi

if [ "$branch" = "dev" ]; then
  echo '[Info] It is the dev branch. Set latest tag.'
  tags+=('latest')
fi

echo "[Debug] Push image $image:$commit"
docker push $image:$commit
for t in ${tags[@]}; do
  echo "[Debug] Tag and push image $image:$t"
  docker tag $image:$commit $image:$t
  docker push $image:$t
done

echo '[Info] post_build is finished'
