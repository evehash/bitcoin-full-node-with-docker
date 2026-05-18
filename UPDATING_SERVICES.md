# Updating services

The process is relatively simple. As soon as a new version of any of the services is released, edit your `.env` file to point to the new version, rebuild the image locally and redeploy the service.

Versions in `.env.example` are the versions tested by this repository. They are not automatically the latest upstream versions. In a recurrent way we update those versions, run the automatic builds and make sure that the deployment process with Docker continues working. If there is a new upstream version and the repository has not been updated, you can try it locally and contribute a focused pull request with your changes.

## How to update a service

Our suggestion is to do it one at a time, verifying by yourself the corresponding `Dockerfile` and making sure that the service is updated correctly. 

The steps are exactly the same for all of the services. So you can follow the steps below just replacing the service name. For this example, the service is `tor` and it will be updated from version `0.4.9.6` to version `0.4.9.8`.

Go to your `.env` file and edit the version parameter:

```conf
# TOR_VERSION=0.4.9.6 -- before
TOR_VERSION=0.4.9.8
```

Next, stop the service and re-run it.

```shell
$ docker compose stop tor
$ docker compose up -d --build tor
```

Check the logs o be sure that the service starts correctly.

```shell
$ docker ps | grep tor
# 06a96296854a   tor:0.4.9.8
$ docker logs 06a96296854a -f
```

If after a while you see that the service is working properly, you can delete the old image.

```shell
$ docker images | grep tor
# REPOSITORY         TAG           IMAGE ID       CREATED         SIZE
# tor                0.4.9.8       236c6c6b89da   7 minutes ago   18.2MB
# tor                0.4.9.5       7ad38075c199   4 weeks ago     18.2MB
$ docker rmi 7ad38075c199
```

## Troubleshooting

In case that something goes wrong during this process, it can be for two reasons:

- Either something has changed in the service and the Dockerfile is not able to rebuild the image. In that case, we will have to review and update the build process in the project.
- The build process is fine but there is a problem with the service or your configuration.

In both cases, you can go back to the previous version that was working before. So simply revert the steps: put the previous version back in the `.env` file and re-run the service. The container you had previously will be deployed and everything should work again.

In the meantime, you can open a thread in the [Discussions](https://github.com/evehash/bitcoin-full-node-with-docker/discussions) section so we can help you.
