--Q1 - Fix or improve the implementation of the below methods

-- It looks like 1000 is an index for storage. So for clarity/readability, I like to make them a constant
STORAGE_VALUE <const> = 1000;

local function releaseStorage(player)
  player:setStorageValue(STORAGE_VALUE, -1)
end

function onLogout(player)
  if player:getStorageValue(STORAGE_VALUE) == 1 then
    addEvent(releaseStorage, 1000, player)
  end
  
  return true
end


--Q2 - Fix or improve the implementation of the below method

function printSmallGuildNames(memberCount)
-- this method is supposed to print names of all guilds that have less than memberCount max members
  local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < %d;"
  local resultId = db.storeQuery(string.format(selectGuildQuery, memberCount))
  
  --[[
  OLD CODE
  local guildName = result.getString("name")
  print(guildName)
  ]]
  
  -- Fetch and print guild names
    while result:next() do
        local guildName = result:get("name")
        print(guildName)
    end
    
    -- Close the result set
    result:free()
    
end


--Q3 - Fix or improve the name and the implementation of the below method
--OLD: function do_sth_with_PlayerParty(playerId, membername)

function removePlayerFromParty(partyPlayerId, memberName) -- changed membername to camelCase
  
  -- Getting player from ID#, also changed variable name for clarity
  player = Player(partyPlayerId) 
  
  local party = psrtyPlayerID:getParty() --Get that player's party
  
  if(party:containsPlayer(Player(memberName)))
    party:removeMember(Player(memberName))
  end
end

-- Created a seperate function, since this would have utility in other cases
function party:containsPlayer(Player)
  for k,v in pairs(party:getMembers()) do
    if v == Player(memberName) then -- If Player with name = memberName is in party
      return true -- remove them
    end
  end
  
  return false;
end

--Q4 - Assume all method calls work fine. Fix the memory leak issue in below method

void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{
  Player* player = g_game.getPlayerByName(recipient);
  if (!player) {
    player = new Player(nullptr);
    if (!IOLoginData::loadPlayerByName(player, recipient)) {
      -- Added this line since player memory allocated wouldn't be used and pointer would be lost
      delete player;
      return;
    }
  }

  Item* item = Item::CreateItem(itemId);
  if (!item) {
    -- No delete here since item would be a nullptr anyway
    return;
  }

  g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);

  if (player->isOffline()) {
    IOLoginData::savePlayer(player);
  }
}