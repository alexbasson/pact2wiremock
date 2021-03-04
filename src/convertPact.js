const { PactConverter } = require('./PactConverter')
const { WireMockStubWriter } = require('./WireMockStubWriter')

const convertPact = (pathToPact, mappingsDir) => {
  const pactConverter = PactConverter(pathToPact)
  const stubWriter = WireMockStubWriter(mappingsDir)

  stubWriter.cleanStubDir()

  pactConverter.toWireMockStubs((err, stubs) => {
    if (err) throw err
    stubs.forEach(stubWriter.writeStubToFile)
  })
}

module.exports = {
  convertPact
}
