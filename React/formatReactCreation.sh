#!/bin/bash
# Creates and formats new react app for common use.
set -e
echo Enter app name && read NAME

echo ----------
echo **Creating React App**
echo ----------

npx create-react-app $NAME
cd $NAME

echo ----------
echo **Updating folder**
echo ----------

cat > tsconfig.json <<EOL
{
  "compilerOptions": {
    "target": "es5",
    "lib": [
      "dom",
      "dom.iterable",
      "esnext"
    ],
    "allowJs": true,
    "skipLibCheck": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "noFallthroughCasesInSwitch": true,
    "module": "esnext",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx",
    "noImplicitAny": false,
    "paths": {
      "@/*": ["./src/*"]
    },
  },
  "include": ["**/*.ts", "**/*.tsx"],
  "exclude": ["node_modules"]
}
EOL

echo Installing SCSS
npm install --save-dev sass

echo ----------
echo **Updating public**
echo ----------

cd public

echo Writing to files

cat > index.html <<EOL
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <link rel="icon" href="%PUBLIC_URL%/favicon.ico" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="theme-color" content="#000000" />
    <meta
      name="description"
      content="Web site created using create-react-app"
    />
    <link rel="apple-touch-icon" href="%PUBLIC_URL%/logo192.png" />
    <link rel="manifest" href="%PUBLIC_URL%/manifest.json" />
    <title>${NAME}</title>
  </head>
  <body>
    <noscript>You need to enable JavaScript to run this app.</noscript>
    <div id="root"></div>
  </body>
</html>
EOL

echo ----------
echo **Updating src**
echo ----------

cd ../src
echo Deleting old files
rm App.js
rm App.css

echo Creating folders
mkdir assets
mkdir containers
mkdir components

mkdir assets/styles
mkdir assets/interfaces

echo Creating SCSS files
touch assets/styles/_mixins.scss
touch assets/styles/_variables.scss
touch assets/styles/_functions.scss

echo Creating App
cat > App.tsx <<EOL
import './App.scss';

function App() {
  return (
    <div className="App">
      App
    </div>
  );
}

export default App;
EOL

printf '@import "./assets/styles/styles";\n\n* {\n  margin: 0;\n  padding: 0;\n box-sizing: border-box;}' > App.scss

cat > assets/styles/_variables.scss <<EOL
// Width breakpoints
\$mobile-breakpoint: 320px;
\$tablet-breakpoint: 768px;
\$desktop-breakpoint: 1024px;
\$large-desktop-breakpoint: 1440px;
\$extra-large-desktop-breakpoint: 2560px;
EOL

cat > assets/styles/_mixins.scss <<EOL
@import "./variables";

@mixin mediaScreenFont(\$desktop-font, \$tablet-font, \$phone-font) {
  font-size: \$phone-font;

  @media screen and (min-width: \$mobile-breakpoint) {
    font-size: \$tablet-font;
  }

  @media screen and (min-width: \$tablet-breakpoint) {
    font-size: \$desktop-font
  }
}
EOL

echo Writing to new files
printf "@import './mixins';\n@import './functions';\n@import './variables';" > assets/styles/_styles.scss

cat > App.test.js <<EOL
import { render, screen } from '@testing-library/react';
import App from './App';

test('Renders App', () => {
  render(<App />);
  const appText = screen.getByText(/App/i);
  expect(appText).toBeInTheDocument();
});
EOL

echo ----------
echo **Updating .github**
echo ----------

echo Adding workflows
cd .. 
mkdir .github 
mkdir .github/workflows 
cd .github/workflows
cat > jest-testing.yml <<EOL
name: React App CI

on: [ push, pull_request ]
jobs:
  build:

    runs-on: ubuntu-latest

    strategy:
      matrix:
        node-version: [16.x]
        # See supported Node.js release schedule at https://nodejs.org/en/about/releases/

    steps:
    - uses: actions/checkout@v2
    - name: Use Node.js \${{ matrix.node-version }}
      uses: actions/setup-node@v2
      with:
        node-version: \${{ matrix.node-version }}
        cache: 'npm'
    - run: npm ci
    - run: npm run build --if-present
    - run: npm test
EOL