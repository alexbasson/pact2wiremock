const { PactInteractionConverter } = require('../src/PactInteractionConverter')

describe('PactInteractionConverter', () => {
  let pactInteractionConverter

  beforeEach(() => {
    pactInteractionConverter = PactInteractionConverter()
  })

  describe('toWireMockStub', () => {
    describe('GET requests', () => {
      const interaction = {
        request: {
          method: 'get',
          path: '/ingredients',
          headers: {
            header1: 'value1',
            header2: 'value2'
          }
        },
        response: {
          status: 200,
          headers: {
            header3: 'value3',
            header4: 'value4'
          },
          body: [
            {
              name: 'some name',
              id: 'some id'
            }
          ]
        }
      }

      let generatedStub

      beforeEach(() => {
        generatedStub = pactInteractionConverter.toWireMockStub(interaction)
      })

      it('generates a request in the correct format', () => {
        expect(generatedStub.request).toEqual({
          method: 'GET',
          url: '/ingredients',
          headers: {
            header1: { equalTo: 'value1' },
            header2: { equalTo: 'value2' }
          }
        })
      })

      it('generates a response in the correct format', () => {
        expect(generatedStub.response).toEqual({
          status: 200,
          headers: {
            header3: 'value3',
            header4: 'value4'
          },
          body: '[{"name":"some name","id":"some id"}]'
        })
      })
    })
  })
})
