#!/usr/bin/env node

const program = require('commander');
const { convertPact } = require('./src/convertPact');

program
  .option(
    '-p, --path-to-pact <type>',
    'The path to the pact file; can be provided by PATH_TO_PACT env variable',
    process.env.PATH_TO_PACT
  )
  .option(
    '-m, --mappings-dir <type>',
    'The directory to save the WireMock stubs to; can be provided by MAPPINGS_DIR env variable',
    process.env.MAPPINGS_DIR
  )
  .parse(process.argv);

const {pathToPact, mappingsDir} = program.opts();

if (!pathToPact || !mappingsDir) {
  let errorMessage = 'Missing the following required values:\n'
  errorMessage += pathToPact ? '' : '\t- the path to the pact file\n';
  errorMessage += mappingsDir ? '' : '\t- the WireMock mappings dir\n';
  errorMessage += 'The required values can be provided as command line arguments or as environment variables.\n'
  errorMessage += 'Run `pact2wiremock -h` for details.\n';
  throw new Error(errorMessage);
}

convertPact(pathToPact, mappingsDir);
