const { v4: uuidv4 } = require('uuid');

const PactInteractionConverter = () => {
  const stubName = (request) => {
    const path = request.path.split('?')[0];
    return request.method.toUpperCase() + '_' + path.replace('/', '').replace(/\//i, '-');
  };

  const toWireMockRequest = (request) => ({
    method: request.method.toUpperCase(),
    url: request.path
  });

  const toWireMockResponse = (response) => ({
    status: response.status,
    headers: response.headers,
    body: JSON.stringify(response.body)
  });

  const toWireMockStub = (interaction) => {
    const uuid = uuidv4();
    return {
      id: uuid,
      name: stubName(interaction.request),
      request: toWireMockRequest(interaction.request),
      response: toWireMockResponse(interaction.response),
      uuid: uuid
    };
  };

  return {
    toWireMockStub
  };
}

module.exports = {
  PactInteractionConverter
};
