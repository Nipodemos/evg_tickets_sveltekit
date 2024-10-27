<script lang="ts">
	import { Input, Label, Checkbox, Button, A, Card } from 'svelte-5-ui-lib';

	import { superForm } from 'sveltekit-superforms';

	const data = $props();

	// Client API:
	const { form, enhance } = superForm(data.form);
</script>

<div class="flex min-h-screen items-center justify-center bg-gray-100">
	<Card class="w-full max-w-md p-6">
		<form class="space-y-6">
			<h3 class="text-center text-xl font-medium text-gray-900 dark:text-white">Login</h3>

			<div>
				<Label for="email" class="mb-2">Email</Label>
				<Input type="email" id="email" placeholder="nome@exemplo.com" required bind:value={email} />
			</div>

			<div>
				<Label for="password" class="mb-2">Senha</Label>
				<Input
					type="password"
					id="password"
					placeholder="••••••••"
					required
					bind:value={password}
				/>
			</div>

			<Button type="submit" class="w-full">Entrar</Button>
		</form>
	</Card>
</div>
