--- main 猜区块
-- bet your block and get reward!
-- @gas_limit 100000
-- @gas_price 0.001
-- @param_cnt 0
-- @return_cnt 0
-- @publisher walleta
function main()
	Assert(Put("max_user_number", 100))
	Assert(Put("user_number", 0))
	Assert(Put("total_coins", 0))
	Assert(Put("last_lucky_block", -1))
	Assert(Put("round", 0))
	Assert(clearUserValue() == 0)
end--f

--- clearUserValue clear user bet value 
-- @param_cnt 0
-- @return_cnt 1
-- @privilege private
function clearUserValue()
	clearTable = {}
	for i = 0, 9, 1 do
		userTableKey = string.format("user_value%d", i)
		Assert(Put(userTableKey, clearTable))
	end
	return 0
end--f

--- Bet a lucky number
-- bet a lucky number with 1 ~ 5 coins
-- @param_cnt 3
-- @return_cnt 1
-- @privilege public
function Bet(account, luckyNumber, coins)
	if (not (coins >= 1 and coins <= 5))
	then
	    return "bet coins should be >=1 and <= 5"
	end
	if (not (luckyNumber >= 0 and luckyNumber <= 9))
	then
	    return "bet lucky number should be >=0 and <= 9"
	end

	_, maxUserNumber = Get("max_user_number")
    _, number = Get("user_number")
    _, totalCoins = Get("total_coins")

	Log(string.format("account = %s, lucky = %d, coin = %f", account, luckyNumber, coins))

	Assert(Deposit(account, coins) == true)
	userTableKey = string.format("user_value%d", luckyNumber)
	Log("after deposit, usertablekey = "..userTableKey)

	_, valTable = Get(userTableKey)
	Log(string.format("val table: %v", valTable))
	if (valTable == nil)
	then
		valTable = {}
	end
	Assert(valTable ~= nil)
	Log("val table not nil")
	Log(string.format("val table account = %f", valTable[account]))
	if (valTable[account] == nil)
	then
		valTable[account] = coins
	else
		valTable[account] = valTable[account] + coins
	end
	Log(string.format("val account = %f", valTable[account]))
	Assert(Put(userTableKey, valTable))

	Log("after put table")
	number = number + 1
	totalCoins = totalCoins + coins
	Assert(Put("user_number", number))
	Assert(Put("total_coins", totalCoins))
	Log(string.format("after put number, number = %d", number))

	if (number >= maxUserNumber)
	then
		Log("number enough")
		blockNumber = Height()
		_, lastLuckyBlock = Get("last_lucky_block")
		pHash = ParentHash()

		if (lastLuckyBlock < 0 or blockNumber - lastLuckyBlock >= 16 or blockNumber > lastLuckyBlock and pHash % 16 == 0)
		then
			Assert(Put("user_number", 0))
			Assert(Put("total_coins", 0))
			Assert(Put("last_lucky_block", blockNumber))
			Assert(getReward(blockNumber, totalCoins, number) == 0)
		end
	end

	return 0
end--f

--- getReward give reward to lucky dogs
-- @param_cnt 3
-- @return_cnt 1
-- @privilege private
function getReward(blockNumber, totalCoins, userNumber)
	Log(string.format("get reward blockNumber = %d, coins = %f, user = %d", blockNumber, totalCoins, userNumber))
	luckyNumber = blockNumber % 10
	_, round = Get("round")
	round = round + 1
	roundKey = string.format("round%d", round)
	roundValue = ""

	userTableKey = string.format("user_value%d", luckyNumber)
	_, valTable = Get(userTableKey)
	if (valTable == nil)
	then
		valTable = {}
	end
	Assert(clearUserValue() == 0)

	totalCoins = totalCoins * 0.95
	totalVal = 0

	kNumber = 0
	for k, v in pairs(valTable) do
		totalVal = totalVal + v
		kNumber = kNumber + 1
	end
	roundValue = roundValue..string.format("%d", blockNumber)
	roundValue = roundValue..string.format("\t%d", userNumber)
	roundValue = roundValue..string.format("\t%d", kNumber)
	roundValue = roundValue..string.format("\t%f", totalCoins)
	if (kNumber > 0)
	then
		unit = totalCoins / totalVal
		for k, v in pairs(valTable) do
			print ("withdraw to  ", k, ", v = ", v * unit)
			Assert(Withdraw(k, v * unit) == true)
			roundValue = roundValue..string.format("\t%s\t%f", k, v * unit)
		end
	end

	Log(roundValue)
	Assert(Put(roundKey, roundValue))
	Assert(Put("round", round))

	return 0
end--f

--- QueryUserNumber query user number now 
-- @param_cnt 0
-- @return_cnt 1
-- @privilege public
function QueryUserNumber()
	ok, r = Get("user_number")
	Assert(ok)
	return r
end--f

--- QueryTotalCoins query total coins
-- @param_cnt 0
-- @return_cnt 1
-- @privilege public
function QueryTotalCoins()
	ok, r = Get("total_coins")
	Assert(ok)
	return r
end--f

--- QueryLastLuckyBlock query last lucky block 
-- @param_cnt 0
-- @return_cnt 1
-- @privilege public
function QueryLastLuckyBlock()
	ok, r = Get("last_lucky_block")
	Assert(ok)
	return r
end--f

--- QueryMaxUserNumber query max user number 
-- @param_cnt 0
-- @return_cnt 1
-- @privilege public
function QueryMaxUserNumber()
	ok, r = Get("max_user_number")
	Assert(ok)
	return r
end--f

--- QueryRound query round
-- @param_cnt 0
-- @return_cnt 1
-- @privilege public
function QueryRound()
	ok, r = Get("round")
	Assert(ok)
	return r
end--f
