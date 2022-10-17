Nginx Unit Server with NodeJS 16 and Python 3.10 modules
===

This is just testing code for [Nginx Unit](https://unit.nginx.org/) so I can run a [Svelte](https://svelte.dev/) frontend with a [FastAPI](https://fastapi.tiangolo.com/) backend.

To Use:
* Build image and Run
  ```
  make
  ```

* Run NodeJS app build
  ```
  make build
  ```

* Configure Unitd
  ```
  make config
  ```

  if there's an error, you can check the container logs:
  ```
  docker logs unit -f
  ```

  or exec into the container and look around:
  ```
  docker exec -ti -w /www unit /bin/bash
  su - unit
  ```

* Restart Apps (as needed)
  The apps will need to be restarted if using a mount and the code is changed on disk.
  ```
  # nodejs
  make app_restart_node

  # fastapi
  make app_restart_fapi
  ```

  or both
  ```
  make app_restart
  ```

Some Reading:
* Nginx Unit - [FastaPI Applications](https://unit.nginx.org/howto/fastapi/)
* Nginx Unit - [Express Applications](https://unit.nginx.org/howto/express/)
* Nginx Unit - [NodeJS 16 Dockerfile](https://github.com/nginx/unit/blob/master/pkg/docker/Dockerfile.node16)
* Nginx Unit - [Python3.10 Dockerfile](https://github.com/nginx/unit/blob/master/pkg/docker/Dockerfile.python3.10)
* [Serving Static Files in Express](https://masteringjs.io/tutorials/express/static)
* Setup NodeJS to work with Svelte without worrying about cross domain issues ([YouTube Video](https://www.youtube.com/watch?v=RpMBkkcxnMo))
* [SvelteKit Routing](https://kit.svelte.dev/docs/routing)
