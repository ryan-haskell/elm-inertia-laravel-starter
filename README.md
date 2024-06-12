# elm-inertia-laravel-starter

Use Laravel and Elm together with Inertia.js!

### Local development

Dependency | How to check
--- | ---
[Composer v2.7.6+ and PHP v8.3.7+](https://herd.laravel.com/) | `composer -V` `php -v`
[sqlite v3.43.2+](https://sqlite.org/) | `sqlite --version`
[Node.js v20.14.0+](https://nodejs.org/) | `node -v`

```sh
# Install PHP and Node dependencies
composer install
npm install

# Run the server at http://localhost:8000
npm run dev
```

### Manual Steps

```sh
# Create a new project
composer create-project laravel/laravel elm-inertia-laravel-starter

# Install Laravel Breeze
composer require laravel/breeze --dev

# Set up frontend stack (chose Vue preset)
php artisan breeze:install

# (Added "php artisan serve" to the "package.json")

# Installed Elm dependencies
npm i -DE elm-inertia vite-plugin-elm-watch

# Initialized elm-inertia (chose Laravel preset)
npx elm-inertia init

# Updated vite.config to include elm Vite plugin
# Updated resources/views/app.blade.php to point to "elm/main.js"
# Deleted resources/js
# Removed vue dependencies

# Ran the dev server
npm run dev
```