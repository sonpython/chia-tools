#!/bin/bash

while IFS= read -r line; do
  IP=$line
  ssh -n -o "StrictHostKeyChecking no" root@$IP $2
done <"$1"
