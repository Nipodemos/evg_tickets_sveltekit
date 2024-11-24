import { message, superValidate } from 'sveltekit-superforms';
import { zod } from 'sveltekit-superforms/adapters';
import type { PageServerLoad } from './$types';

import { z } from 'zod';

const schema = z.object({
	login: z.string().min(3, 'Mínimo de 3 caracteres'),
	senha: z.string().min(3, 'Mínimo de 3 caracteres')
});

export const load: PageServerLoad = async () => {
	const form = await superValidate(zod(schema));

	return { form };
};

export const actions = {
	default: async (event) => {
		const form = await superValidate(event, zod(schema));
		await sleep(1000);
		return message(form, 'success');
	}
};
function sleep(ms: number) {
	return new Promise((resolve) => setTimeout(resolve, ms));
}
