const { rmSync, mkdirSync, writeFileSync } = require('fs');

const WireMockStubWriter = (mappingsDir) => {
  const writeStubToFile = (stub) => {
    const stubFilename = stub.name + '_' + stub.id + '.json';
    writeFileSync(mappingsDir + stubFilename, JSON.stringify(stub));
  };

  const cleanStubDir = () => {
    rmSync(mappingsDir, { recursive: true, force: true });
    mkdirSync(mappingsDir);
  }

  return {
    cleanStubDir,
    writeStubToFile
  };
}

module.exports = {
  WireMockStubWriter
};
