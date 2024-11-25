## Vidtube Prject: [Backend project structure](https://www.youtube.com/watch?v=eDHl26DWrk4)
### Initializing npm packages
```shell
npm init
This utility will walk you through creating a package.json file.
It only covers the most common items, and tries to guess sensible defaults.

See `npm help init` for definitive documentation on these fields
and exactly what they do.

Use `npm install <pkg>` afterwards to install a package and
save it as a dependency in the package.json file.

Press ^C at any time to quit.
package name: (vidtube)
version: (1.0.0)
description: a project inpired by youtube
entry point: (index.js) src/index.js
test command:
git repository:
keywords: nodejs, mongoose, express, backend
author: khaleel Ahmad
license: (ISC)
```

1. It will create package.json file
2. Added "type": "module", in package.json # love to use module based system
3. Dev dependicies:
    `npm i --save-dev nodemon  prettier`
    # added dev dependencies in package.json
    # added two files .prettierrc and .prettierignore in root
    # .prettierrc content is:
        ```json{
        "singleQuote": false,
        "bracketSpacing": true,
        "tabWidth": 2,
        "trailingComma": "es5",
        "semi": true}
        ```
    # .prettierignore content is:
    ```yaml
        /.vscode
        /node_modules
        ./dist

        *.env
        .env
        .env.*
    ```
4. Create an src folder
    # separation of concerns, separate: functionaly known as controller, models: db models, routes: urls
    # Folders: 
        `mkdir controllers db middlewares models routes utils`
    # Files:
        `touch app.js index.js contstants.js .env .env.sample readme.md'
    # Database connection file:
        `touch index.js'
5. Create files under 'src/models'
    `touch comment.models.js like.models.js playlist.models.js subscription.models.js tweet.models.js user.models.js video.model.js'
6. Each model has controllers, so we have to create files under controllers folder as well
7. ORMs under root, mongoose installation for ORM database
    `npm i express mongoose`
8. Added "start": "node src/index.js" in package.json under scripts
9. Run start:
    ```shell
    khaleel@Khaleel:~/DevOPS/Web/vidtube$ npm run start
    > vidtube@1.0.0 start
    > node src/index.js

    Hello World
    khaleel@Khaleel:~/DevOPS/Web/vidtube$
    ```
10: Added "dev": "nodemon src/index.js" under scripts   
