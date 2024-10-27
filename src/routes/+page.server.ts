import { superValidate } from 'sveltekit-superforms';
import { arktype } from 'sveltekit-superforms/adapters';
import type { PageServerLoad } from './$types';
import { type } from 'arktype';

const schema = type({
	login: 'string',
	senha: 'string'
});
type tipagem = typeof schema.infer;
const defaults = {
	login: '',
	senha: ''
};

export const load: PageServerLoad = async () => {
	const form = await superValidate(arktype(schema, { defaults }));
	return { form };
};
