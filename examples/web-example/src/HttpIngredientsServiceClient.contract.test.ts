import {Pact} from '@pact-foundation/pact';
import path from 'path';
import {v4 as uuidv4} from 'uuid';
import {eachLike} from "@pact-foundation/pact/src/dsl/matchers";

interface Ingredient {
    id: string,
    name: string
}

interface IngredientServiceClient {
    fetchIngredients(): Promise<Ingredient[]>;
}

const someUuid = uuidv4();

class HttpIngredientServiceClient implements IngredientServiceClient {

    constructor(private baseUrl: string) {
    }

    async fetchIngredients(): Promise<Ingredient[]> {
        return fetch(`${this.baseUrl}/ingredients`, {
            method: 'GET',
            headers: {
                'Accept': 'application/json'
            }
        })
            .then(response => response.json());
    }
}

describe('HttpIngredientsServiceClient contract', () => {
    let ingredientsServiceClient: HttpIngredientServiceClient;

    const port = 1234;

    const provider = new Pact({
        consumer: 'web-example',
        provider: 'ingredient-service',
        port: port,
        log: path.resolve(process.cwd(), 'logs', 'pact.log'),
        dir: path.resolve(process.cwd(), 'pacts'),
        spec: 2
    });

    const expectedIngredient: Ingredient = {
        id: someUuid,
        name: 'Butter'
    };

    beforeEach(() => {
        ingredientsServiceClient = new HttpIngredientServiceClient(`http://localhost:${port}`);
    })

    afterEach(() => provider.finalize());

    describe('fetchIngredients()', () => {
        beforeEach(async () => {
            await provider.setup();
            provider.addInteraction({
                state: 'there is a list of ingredients',
                uponReceiving: 'a request for the ingredients',
                withRequest: {
                    method: 'GET',
                    path: '/ingredients',
                    headers: {
                        Accept: 'application/json'
                    }
                },
                willRespondWith: {
                    status: 200,
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: eachLike(expectedIngredient)
                }
            });
            console.log('===================> Check interaction');
        });

        afterEach(() => {
            provider.verify()
        });

        it('fetches the ingredients', async () => {
            const ingredients = await ingredientsServiceClient.fetchIngredients();
            expect(ingredients.length).toBe(1);
            expect(ingredients[0]).toEqual(expectedIngredient);
        });
    });
});
