#!/bin/bash
# Exit if error occurs
set -e
# 
# Component name
echo Please input a name && read NAME
# 
# File path location (for the folder, relative to where this script is)
LOCATION="./src/containers/"
#
# Writing to files
cd ${LOCATION}
mkdir ${NAME} && cd ${NAME}
touch "${NAME}.tsx" && touch "${NAME}.test.js" && touch "${NAME}.scss"
printf "@import \"../../assets/styles/styling\";" > ${NAME}.scss

cat > ${NAME}.tsx <<EOL
import './${NAME}.scss';

const ${NAME} = (props) => {
  
  return (
    <div>${NAME}</div>
  )
};

export default ${NAME};
EOL

cat > ${NAME}.test.js <<EOL
import ${NAME} from './${NAME}';
import { render, screen } from "@testing-library/react";

const setupRender = () => {
  return render(<${NAME} />);
}

describe('Rendering tests', () => {

  test('Check rendering of component name', () => {
    setupRender();

    const componentName = screen.getByText("${NAME}");

    expect(componentName).toBeInTheDocument();
  });
});

describe('Functional tests', () => {});
EOL