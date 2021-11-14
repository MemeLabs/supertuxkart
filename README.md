# supertuxkart server

For hosting a server, please read and follow any guidelines outlined
[here](https://github.com/supertuxkart/stk-code/blob/master/NETWORKING.md).

Run on podman/docker

```bash
# write out and customize the server_config.xml file (found in above link)
podman run \
  --detach \
  --network=host \
  --env STK_USERNAME=${STK_USERNAME} \
  --env STK_PASSWORD=${STK_PASSWORD} \
  --volume config/:/tmp/config/ \
  ghcr.io/jbpratt/supertuxkart/server:latest --server-config=/tmp/config/server_config.xml
```

Run on Kubernetes

```bash
kubectl kustomize https://github.com/jbpratt/supertuxkart | kubectl apply -f -
# add credentials to the secret created
kubectl edit secret credentials -n supertuxkart
# customize the server_config.xml
kubectl edit cm config -n supertuxkart
```
