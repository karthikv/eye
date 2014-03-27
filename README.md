# Eye
The all-seeing Eye manages Scoryst's server configuration. It spins up and
provisions Amazon EC2 instances that can immediately be used for development or
production.

## Installation
You'll need to install four dependencies before using eye:

- [Fucking shell scripts](http://fuckingshellscripts.org/) via `gem install
  fucking_shell_scripts`
- [Gulp](http://gulpjs.com/) via `npm install -g gulp`
- [Safe](https://github.com/scoryst/safe) via the [GitHub
  repository](https://github.com/scoryst/safe)
- All `package.json` dependencies via `npm install`

## Configuration
Many files that Eye needs are not in the git repository for security reasons.
To fetch them, simply run:

```sh
$ safe fetch safe.yml
```

If `safe` tells you the files don't exist, they haven't been released to you.
Talk to Karthik and he'll resolve this issue.

## Usage
Using Eye is quite simple. To spin up a development server, just run:

```sh
$ make dev
```

You can find the IP address on the AWS console. Visit the IP in your browser to
see Scoryst running. You can log onto the dev machine like so:

```sh
$ ssh deploy@[IP] -p 20000
```

Your public SSH key is automatically added to the machine's authorized\_keys,
so you don't need a password. Some notes about the development server:

- Everything you care about is probably in the `/home/deploy/scoryst`
  directory.
- Gunicorn serves the Scoryst Django app and is automatically running. The logs
  are in `/home/deploy/scoryst/logs/supervisor-gunicorn.log`. Restart gunicorn
  after modifying files by running `supervisorctl restart scoryst`. This only
  needs to be done if you've modified backend files.
- A Celery worker is also automatically running. The logs are in
  `/home/deploy/scoryst/logs/supervisor-celery-worker.log`. Restart Celery
  after modifying files by running `supervisorctl restart
  scoryst-celery-worker`.
- Redis is running for Django and Celery to interface with.
- Memcached is running as a fast caching backend for Django.
- In case anything goes wrong with nginx, the logs are at
  `/home/deploy/scoryst/logs/nginx-access.log` and
  `/home/deploy/scoryst/logs/nginx-error.log`. Restart nginx by running
  `service nginx restart`.

To spin up a production server, run:

```sh
$ make prod
```

The production server will only function correctly if you set a DNS A record on
scoryst.com that points to the machine's IP address. Note that you should
attach an elastic IP to the machine so as to prevent the IP address from
changing across restarts. This can be done in the AWS console.
