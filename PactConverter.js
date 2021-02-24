const { readFile } = require('fs');
const { PactInteractionConverter } = require('./PactInteractionConverter');

const PactConverter = (pathToPact) => {
  const interactionConverter = PactInteractionConverter();

  const toWireMockStubs = (callback) => {
    readFile(pathToPact, (err, data) => {
      const pact = JSON.parse(data);
      const stubs = pact.interactions.map(interactionConverter.toWireMockStub);
      callback(err, stubs);
    });
  };

  return {
    toWireMockStubs
  };
}

module.exports = {
  PactConverter
};
