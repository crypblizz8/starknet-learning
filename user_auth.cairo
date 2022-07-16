%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_nn
from starkware.starknet.common.syscalls import get_caller_address

# A map from user (represented by account contract address)
# to their balance.
@storage_var
func balance(user : felt) -> (res : felt):
end

# the address of the source contract that called this contract. 
# It can be the address of the account contract or the address of another contract (if the function was invoked by another contract). 
# let (caller_address) = get_caller_address()

# Allowing for different args.
# func read{
#         syscall_ptr : felt*, range_check_ptr,
#         pedersen_ptr : HashBuiltin*}(
#     user : felt) -> (res : felt):
# end

# func write{
#         syscall_ptr : felt*, range_check_ptr,
#         pedersen_ptr : HashBuiltin*}(
#     user : felt, value : felt):
# end

# Increases the balance of the user by the given amount.
@external
func increase_balance{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr,
}(amount : felt):
    # Verify that the amount is positive.
    with_attr error_message(
            "Amount must be positive. Got: {amount}."):
        assert_nn(amount)
    end

    # Obtain the address of the account contract.
    let (user) = get_caller_address()

    # Read and update its balance.
    let (res) = balance.read(user=user)
    balance.write(user, res + amount)
    return ()
end

# Returns the balance of the given user.
@view
func get_balance{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr,
}(user : felt) -> (res : felt):
    let (res) = balance.read(user=user)
    return (res)
end