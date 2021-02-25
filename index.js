#!/usr/bin/env node

const program = require('commander');
const { PactConverter } = require('./src/PactConverter');
const { WireMockStubWriter } = require('./src/WireMockStubWriter');

program
  .option('-p, --pathToPact <pathToPact>', 'The path to the pact file; can be provided by PATH_TO_PACT env variable')
  .option('-m, --mappingsDir <mappingsDir>', 'The directory to save the WireMock stubs to; can be provided by MAPPINGS_DIR env variable')
  .parse(process.argv);

const convertPact = (pathToPact, mappingsDir) => {
  const pactConverter = PactConverter(pathToPact);
  const stubWriter = WireMockStubWriter(mappingsDir);

  stubWriter.cleanStubDir();

  pactConverter.toWireMockStubs((err, stubs) => {
    if (err) throw err;
    stubs.forEach(stubWriter.writeStubToFile);
  });
}

const options = program.opts();
const pathToPact = options.pathToPact || process.env.PATH_TO_PACT
const mappingsDir = options.mappingsDir || process.env.MAPPINGS_DIR

let errorMessage = 'Missing the following required values:\n'
errorMessage += pathToPact ? '' : '\t- the path to the pact file\n';
errorMessage += mappingsDir ? '' : '\t- the WireMock mappings dir\n';
errorMessage += 'The required values can be provided as command line arguments or as environment variables.\n'
errorMessage += 'Run `pact2wiremock -h` for details.\n';

if (!pathToPact || !mappingsDir) {
  throw new Error(errorMessage);
}

convertPact(pathToPact, mappingsDir);
