<script lang="ts">
	import { Input, Label, Checkbox, Button, A, Card } from 'svelte-5-ui-lib';

	import { superForm } from 'sveltekit-superforms';
	import type { PageData } from './$types';

	const { data }: { data: PageData } = $props();
	console.log('data :>> ', data);

	// Client API:
	const { form, enhance, constraints } = superForm(data.form);
</script>

<div class="flex min-h-screen items-center justify-center bg-gray-100">
	<Card class="w-full max-w-md p-6">
		<form use:enhance class="space-y-6">
			<h3 class="text-center text-xl font-medium text-gray-900 dark:text-white">Login</h3>

			<div>
				<Label for="login" class="mb-2">Login</Label>
				<Input
					type="login"
					id="login"
					placeholder="nome@exemplo.com"
					{...$constraints.login}
					bind:value={$form.login}
				/>
			</div>

			<div>
				<Label for="password" class="mb-2">Senha</Label>
				<Input
					type="password"
					id="password"
					placeholder="••••••••"
					{...$constraints.senha}
					bind:value={$form.senha}
				/>
			</div>

			<Button type="submit" class="w-full">Entrar</Button>
		</form>
	</Card>
</div>
