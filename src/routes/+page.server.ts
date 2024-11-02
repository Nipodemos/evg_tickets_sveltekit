import { superValidate } from 'sveltekit-superforms';
import { zod } from 'sveltekit-superforms/adapters';
import type { PageServerLoad } from './$types';

import { z } from 'zod';

const schema = z.object({
	login: z.string(),
	senha: z.string()
});

export const load: PageServerLoad = async () => {
	const form = await superValidate(zod(schema));

	return { form };
};
