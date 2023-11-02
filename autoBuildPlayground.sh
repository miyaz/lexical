#!/bin/bash

git clone https://github.com/facebook/lexical.git
cp -rf lexical/packages/lexical-playground .
cp -rf lexical/packages/shared lexical-playground/shared/
#cp -rf lexical/scripts lexical-playground/
cd lexical-playground
npm i
npm -D i @babel/plugin-transform-flow-strip-types @babel/preset-react @rollup/plugin-babel

#cat <<EOS > ../vite.config.js.patch
#@@ -187,7 +187,7 @@ export default defineConfig({
#       plugins: [
#         '@babel/plugin-transform-flow-strip-types',
#         [
#-          require('../../scripts/error-codes/transform-error-messages'),
#+          require('./scripts/error-codes/transform-error-messages'),
#           {
#             noMinify: true,
#           },
#@@ -198,7 +198,12 @@ export default defineConfig({
#     react(),
#   ],
#   resolve: {
#-    alias: moduleResolution,
#+    alias: [
#+      {
#+        find: 'shared',
#+        replacement: path.resolve('./shared/src'),
#+      },
#+    ],
#   },
#   build: {
#     outDir: 'build',
#EOS
#
#patch -u vite.config.js < ../vite.config.js.patch

cat <<EOS > ../vite.prod.config.js.patch
@@ -181,7 +181,12 @@ export default defineConfig({
     react(),
   ],
   resolve: {
-    alias: moduleResolution,
+    alias: [
+      {
+        find: 'shared',
+        replacement: path.resolve('./shared/src'),
+      },
+    ],
   },
   build: {
     outDir: 'build',
EOS

patch -u vite.prod.config.js < ../vite.prod.config.js.patch

npm run build-prod
mv build build-prod

#npm run build-dev
#mv build build-dev

