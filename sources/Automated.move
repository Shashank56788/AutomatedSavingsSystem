module MyModule::AutomatedSavings {
    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    struct SavingsAccount has store, key {
        percentage: u64, // Savings percentage (e.g., 10 for 10%)
        balance: u64,    // Saved amount
    }

    /// Function to set the savings percentage for a user.
    public fun set_savings_percentage(user: &signer, percentage: u64) {
        assert!(percentage <= 100, 1); // Ensure valid percentage
        move_to(user, SavingsAccount { percentage, balance: 0 });
    }

    /// Function to automatically save a percentage of the income.
    public fun auto_save(user: &signer, income: u64) acquires SavingsAccount {
        let account = borrow_global_mut<SavingsAccount>(signer::address_of(user));
        let save_amount = (income * account.percentage) / 100;

        // Transfer savings to the user's account
        let savings = coin::withdraw<AptosCoin>(user, save_amount);
        coin::deposit<AptosCoin>(signer::address_of(user), savings);

        account.balance = account.balance + save_amount;
    }
}
