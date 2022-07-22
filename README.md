Adding stories to github
========================

```bash
$ git init -b main
$ git add -A
$ git commit -m "initial commit"
```

I followed instructions from:

	https://docs.github.com/en/get-started/importing-your-projects-to-github/importing-source-code-to-github/adding-locally-hosted-code-to-github

Unfortunately, they didn't work. To make it work, I had to cd to the
parent folder, then run 'gh repo create'.

At the initial prompt, you should select:

	Push an existing local repository to GitHub

After that, you won't see the prompt, just a '?'. Enter the name of
the folder, which will become the name of the repo.

Furthermore, later prompts also do not appear, so you should just
keep hitting 'Enter' and eventually you'll get your bash prompt
back and the repo will be created at GitHub.
