module ATM_Controller_Testbench;
  reg clk;
  reg reset;
  reg card_inserted;
  reg pin_entered;
  reg transaction_selected;
  reg transaction_processed;
  reg card_ejected;
  reg withdrawal_requested;
  reg deposit_requested;
  reg balance_requested;
  wire card_eject;
  wire [3:0] transaction;
  wire withdrawal_completed;
  wire deposit_completed;
  wire [15:0] old_balance;
  wire [15:0] new_balance;
  wire [15:0] mini_statement;

  ATM_Controller atm_controller (
    .clk(clk),
    .reset(reset),
    .card_inserted(card_inserted),
    .pin_entered(pin_entered),
    .transaction_selected(transaction_selected),
    .transaction_processed(transaction_processed),
    .card_ejected(card_ejected),
    .withdrawal_requested(withdrawal_requested),
    .deposit_requested(deposit_requested),
    .balance_requested(balance_requested),
    .card_eject(card_eject),
    .transaction(transaction),
    .withdrawal_completed(withdrawal_completed),
    .deposit_completed(deposit_completed),
    .old_balance(old_balance),
    .new_balance(new_balance),
    .mini_statement(mini_statement)
  );

  initial begin
    clk = 0;
    reset = 1;
    card_inserted = 0;
    pin_entered = 0;
    transaction_selected = 0;
    transaction_processed = 0;
    card_ejected = 0;
    withdrawal_requested = 0;
    deposit_requested = 0;
    balance_requested = 0;

    #10 reset = 0; // Assert reset

    // Test case 1: Card inserted, valid PIN entered, withdrawal requested
    card_inserted = 1;
    pin_entered = 1;
    withdrawal_requested = 1;
    #20;
    // Expected outputs:
    // card_eject = 1 (Withdrawal in progress)
    // transaction = 4'b0001 (Withdrawal)
    // withdrawal_completed = 0
    // deposit_completed = 0
    // old_balance = 0 (Initial balance)
    // new_balance = 0 - transaction (Updated balance)
    // mini_statement = 0 (No mini statement requested)
    $display("Test case 1:");
    $display("card_eject = %b, transaction = %b, withdrawal_completed = %b, deposit_completed = %b, old_balance = %d, new_balance = %d, mini_statement = %d",
      card_eject, transaction, withdrawal_completed, deposit_completed, old_balance, new_balance, mini_statement);

    // Test case 2: Transaction processed, card ejected
    transaction_processed = 1;
    card_ejected = 1;
    #20;
    // Expected outputs:
    // card_eject = 0 (No transaction in progress)
    // transaction = 4'b0000 (No transaction selected)
    // withdrawal_completed = 1
    // deposit_completed = 0
    // old_balance = 0 - transaction (Previous balance)
    // new_balance = 0 - transaction (Updated balance)
    // mini_statement = 0 (No mini statement requested)
    $display("Test case 2:");
    $display("card_eject = %b, transaction = %b, withdrawal_completed = %b, deposit_completed = %b, old_balance = %d, new_balance = %d, mini_statement = %d",
      card_eject, transaction, withdrawal_completed, deposit_completed, old_balance, new_balance, mini_statement);

    // Test case 3: Card inserted, invalid PIN entered three times
    card_inserted = 1;
    pin_entered = 0;
    #20;
    // Expected outputs:
    // card_eject = 1 (Locked state)
    // transaction = 4'b0000 (No transaction selected)
    // withdrawal_completed = 0
    // deposit_completed = 0
    // old_balance = 0 (Previous balance)
    // new_balance = 0 (Previous balance)
    // mini_statement = 0 (No mini statement requested)
    $display("Test case 3:");
    $display("card_eject = %b, transaction = %b, withdrawal_completed = %b, deposit_completed = %b, old_balance = %d, new_balance = %d, mini_statement = %d",
      card_eject, transaction, withdrawal_completed, deposit_completed, old_balance, new_balance, mini_statement);

    // Add more test cases as needed...

    $finish;
  end

  always begin
    #5 clk = ~clk; // Toggle clock every 5 time units
  end

endmodule