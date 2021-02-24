#!/usr/bin/env node

const program = require('commander');
const { PactConverter } = require('./PactConverter');
const { WireMockStubWriter } = require('./WireMockStubWriter');

program
  .option('-p, --pathToPact <pathToPact>', 'The path to the pact file')
  .option('-m, --mappingsDir <mappingsDir>', 'The directory to save the WireMock stubs to')
  .parse(process.argv);

const convertPact = ({pathToPact, mappingsDir}) => {
  const pactConverter = PactConverter(pathToPact);
  const stubWriter = WireMockStubWriter(mappingsDir);

  stubWriter.cleanStubDir();

  pactConverter.toWireMockStubs((err, stubs) => {
    if (err) throw err;
    stubs.forEach(stubWriter.writeStubToFile);
  });
}

convertPact(program.opts());
