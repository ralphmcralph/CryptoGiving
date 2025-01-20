# CryptoGiving

CryptoGiving is a smart contract written in Solidity that enables fundraising in Ether (ETH). It allows users to make donations while enforcing a minimum donation amount and supports refunding excessive contributions when the fundraising goal is reached.

## Features
- **Fundraising Goal:** A target amount in Ether that must be reached.
- **Minimum Donation Amount:** Donations below the set minimum are rejected.
- **Automatic Refunds:** Excess funds are automatically refunded when the goal is reached.
- **Custom Rewards:** Donors receive personalized thank-you messages based on their donation size.
- **Owner-Controlled Withdrawals:** Only the contract owner can withdraw the funds once the campaign is completed.

---

## Contract Details

### Variables
- **`donations`**: A mapping to store the total donations per address.
- **`owner`**: The address of the contract owner.
- **`goal`**: The fundraising target (in Wei).
- **`goalReached`**: A boolean indicating whether the fundraising goal has been reached.
- **`MIN_DONATION`**: The minimum allowed donation (default: 0.02 ETH).

---

### Constructor
The constructor initializes the contract with:
- **`_goal`**: The fundraising target in multiples of `0.1 ether`.

Example:
If `_goal` is `5`, the target will be `0.5 ether`.

---

### Modifiers
- **`donationTooSmall`**: Ensures that the donation amount is at least `MIN_DONATION`.
- **`onlyOwner`**: Restricts access to the contract owner.
- **`checkGoalReached`**: Prevents further donations once the goal is reached.

---

### Events
- **`DonationReceived`**: Emitted whenever a donation is made, with the donor's address, amount, and a reward message.
- **`GoalReached`**: Emitted when the fundraising goal is reached, with the total contract balance.

---

### Functions

#### 1. `donate()`
Allows users to donate ETH to the campaign.
- **Parameters:** None
- **Logic:**
  - Rejects donations below the minimum amount (`MIN_DONATION`).
  - Refunds any excess if the donation causes the contract balance to exceed the goal.
  - Updates the `donations` mapping with the donor's contribution.
  - Emits the `DonationReceived` event with a personalized thank-you message.

#### 2. `withdraw()`
Allows the owner to withdraw the funds after the campaign.
- **Access Control:** Only the owner can call this function.
- **Logic:**
  - Transfers the contract's balance to the owner's address.
  - Emits no events.

#### 3. `getContractBalance()`
Returns the current balance of the contract in Wei.
- **Access Control:** Publicly accessible.

---

## How to Use

### Deploying the Contract
1. Deploy the contract using any Solidity-compatible environment (e.g., Remix, Hardhat).
2. Pass the `_goal` argument to the constructor, representing the fundraising target as a multiple of `0.1 ether`.

Example: Deploying with `_goal = 5` sets the target to `0.5 ether`.

### Making a Donation
1. Call the `donate()` function and attach ETH to the transaction.
2. Ensure the donation amount meets or exceeds the `MIN_DONATION` value (default: 0.02 ETH).

### Withdrawing Funds
- Once the fundraising goal is reached, the contract owner can call `withdraw()` to transfer the funds to their address.

---

## Testing

### Testing in Remix
1. Deploy the contract with a valid `_goal` argument.
2. Test the following scenarios:
   - Make a donation below the minimum amount (should fail).
   - Make a donation that meets or exceeds the minimum.
   - Make a donation that causes the balance to exceed the goal (should trigger a refund).
3. Verify the `donations` mapping and contract balance.
4. Call `withdraw()` as the owner and verify the fund transfer.

---

## License
This project is licensed under the [LGPL-3.0-only](https://www.gnu.org/licenses/lgpl-3.0.html).

---

## Notes
- All amounts are internally handled in Wei (1 Ether = 10^18 Wei).
- Ensure sufficient gas for transactions, especially for donations and withdrawals.
- This contract is designed for educational and demonstrative purposes; use it responsibly in real-world scenarios.
