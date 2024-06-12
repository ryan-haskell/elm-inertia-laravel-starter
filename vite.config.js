import { defineConfig } from 'vite'
import laravel from 'laravel-vite-plugin'
import elm from 'vite-plugin-elm-watch'

export default defineConfig({
  plugins: [
    laravel({
        input: 'resources/elm/main.js',
        refresh: true,
    }),
    elm()
  ]
})