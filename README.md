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

Put your web site on the Internet
=================================

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

Preparation
-----------

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

Now, we're almost ready to deploy. But first, we'll want to
commit all of our code to `git`, a source code management
system. Later on, we'll make sure there's a copy of our code
somewhere outside of our local computer, but for now, git will
just keep it locally. Execute these commands:

```bash
$ git init
$ git add -A
$ git commit -m "initial commit"
```

After that, if you run the command `git status`, you should
see the following message:

```text
On branch master
nothing to commit, working tree clean
```

It's possible that instead of 'On branch master', it will
say 'On branch main'. If so, that's fine. But generally you
should make sure that your code is committed to get before
deploying it to the Internet.

Deploy to the Internet
----------------------

Run surge to deploy your app to the Internet:

```bash
> surge ./build
```

When prompted, enter your email address and a password.
If you have an existing surge account, use that. Otherwise,
a new, free, account is set up for you.

Note that we've specified the project to upload - ./build
If you're prompted for the project, make sure you use that.

When prompted for a domain, surge will suggest one,
but you can change that in place - use your left arrow key to position
the cursor, backspace to delete existing characters, and normal keys
to edit the name. Just make sure it ends with
`.surge.sh`. If the name is already in use, you will
be told that and allowed to try again with another name.
For the purpose of this example, we'll use `jd-stories.surge.sh`.
NOTE: You will not be able to use that name for your project
because I'm using it! Try using your initials
in place of mine (jd).

I will refer to the domain you used as **<domain>** in the
following

When done, your web site will be on the Internet!

try entering the URL http://<domain> or https://<domain> in
your browser and check it out! The first, non-SSL URL should
actually redirect to the second SSL URL.

Modify package.json by adding key under scripts:

```javascript
"deploy": "npm run build && surge ./build --domain https://<domain>"
```

Be sure to 1) replace <domain> with your domain, and 2) add a
comma to the end of the preceding line - JSON requires that
keys be separated by a comma and (unfortunately) that the last
line in a set of keys does NOT have a trailing comma.

Try making a change to your home page, i.e. the file
`src/routes/+page.svelte`,
then re-deploying. For example, add the line:

```html
<p>by me!</p>

The web page running the development server (if you still have
it running), should show the change immediately. To deploy that
version to the Internet, execute the command:

```bash
$ npm run deploy
```

which will re-build your project, then deploy it to surge's
servers. Try the URL `https://<domain>` in your browser. If
you already had that page open in your browser, you can just
refresh the page. Pages deployed to the Internet won't
automatically update when changes are made the way they do
when you're developing.

Normally, you wouldn't deploy the new web page without first
testing it with the development and preview server, and committing
all of your code to git. However, in
this case the change was very simple, and I wanted to show how
simple deploying a new web page can be.

From this point on, we will make all changes locally. Just
remember that when the web site works as you intend and you
want that version of the web site on the Internet, you can
simply execute:

```bash
$ npm run deploy
```

Add web pages
=============

Next, we're going to add 2 pages: an About page and a Help page. They
won't have much on them yet bit I want to show how to add pages to
your web site, then later create a menu for accessing those pages.

In your `src/routes` folder, add 2 new directories named `About`
and `Help`. Inside the new `About` folder, add this file and
name it `+page.svelte`:

```svelte
<h1>About this web site</h1>
<p>TODO: add a description of the web site</p>
```

Inside the new `Help` folder, add this file and
name it `+page.svelte`:

```svelte
<h1>Help</h1>
<p>TODO: provide some help</p>
```

Now, to access those pages, modify your home page (i.e. the file
named `+page.svelte` inside your `src/routes` folder) to:

Now, when you visit your web site, you'll see a very simple menu
at the top of the page that will let you view the `About` and `Help`
pages. Unfortunately, when you visit one of those pages, the menu
disappears and you'll need to use the browser's `Back` button to
go back to the home page. We'll fix that next. Before we do that,
though, let's try deploying this version. First, commit all your
code to git:

```bash
$ git status
```

This will show you which files have been changed or added. Next:

```bash
$ git add -A
$ git commit -m "add About and Help pages"
```

Next deploy to the Internet:

```bash
$ npm run deploy
```

After that, you should be able to access your web site on the
Internet in your browser to see the changes made.

Creating a layout
=================

