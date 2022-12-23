Build this web site
===================

```bash
$ npm create svelte@latest stories
$ cd stories
$ mkdir src/lib
$ npm install
$ npm run dev -- --open
```

Change src/routes/+page.svelte to:

```html
<h1>Stories</h1>
<p>Stories will be listed here</p>
```

Note the immediate change to your web page.

Deploy to the Internet
======================

It's never too early to put your web site on the Internet
so you can share it with your friends. You'll gradually
make it better and better, but it will always be
available on the Internet. We're going to create a
completely static web site. Don't worry - the pages themselves
will be very dynamic - but we won't be needing any external
database, so we can build all of our HTML pages before
deploying them to the Internet as plain HTML pages.

We'll be using the `surge` command to deploy files to the
Internet. Their web site is at `https://surge.sh`. But you
don't need to use their web site at all. It's enough to install
the `surge` command using npm, then employing the `surge`
command. The first time you use it, you'll be asked for your
email address and to provide a password. It's free to use,
though your bandwidth is limited, so if you ever anticipate
a large amount of traffic to your web site, you'll need to
pay to increase that bandwidth limit. But for what we're going
to do, it's ideal.

Install the command with:

```bash
$ npm install -g surge
```

Before we use the command, though, we'll need to do some
preparation. First, install svelte's static adapter:

```bash
$ npm install -D @sveltejs/adapter-static@latest
```

Configure the adapter by opening the file `svelte.config.js`
and changing "adapter-auto" to "adapter-static".

Next, we need to tell svelte that all pages will be prerendered
at build time. I.e. no pages are rendered on the server while
the web site is running - they're all built ahead of time. To do
that, create the file `src/routes/+layout.server.js` containing:

```js
export const prerender = true;
```

Now, you can build your web site (which prerenders all of
the web page) with:

```bash
$ npm run build
```

That will create a new directory named `build` in your project
directory. Next, you can test the site locally via:

```bash
$ npm run preview -- --open
```

