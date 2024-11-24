<script lang="ts">
	import { Input, Label, Button, Card, Spinner } from 'svelte-5-ui-lib';
	import SuperDebug, { superForm } from 'sveltekit-superforms';
	import { Field } from 'formsnap';
	import type { PageData } from './$types';

	const { data }: { data: PageData } = $props();
	$inspect(data);

	// Client API:
	const { form, enhance, constraints, submitting } = superForm(data.form);
</script>

<div class="flex min-h-screen items-center justify-center bg-gray-100">
	<Card class="w-full max-w-md p-6">
		<SuperDebug data={form} />
		<form use:enhance class="space-y-6">
			<h3 class="text-center text-xl font-medium text-gray-900 dark:text-white">Login</h3>

			<div>
				<Field {form} name="login">s</Field>
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

			<Button type="submit" class="w-full">
				{#if $submitting}
					<Spinner />
				{/if}
				Entrar
			</Button>
		</form>
	</Card>
</div>
