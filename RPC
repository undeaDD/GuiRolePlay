package xyz.undeaD_D.RPC;
import java.lang.reflect.Field;
import java.util.HashMap;
import org.bukkit.ChatColor;
import org.bukkit.command.CommandExecutor;
import org.bukkit.configuration.file.FileConfiguration;
import org.bukkit.enchantments.Enchantment;
import org.bukkit.plugin.java.JavaPlugin;


	public class RPC extends JavaPlugin implements CommandExecutor {
		protected String prefix;
		protected FileConfiguration config;
		protected CommandListener cmd;
		protected EventListener event;
		protected SQL sql;
		protected Enchantment ench;
		protected ConversationManager conversation;
		
		
		public void onEnable() {
			ench = EnchantGlow.getGlow();
			
			config = getConfig();
			config.options().copyDefaults(true);
			saveConfig();

			prefix = ChatColor.translateAlternateColorCodes('&', config.getString("messages.prefix"));
			new Updater(this);
			
			conversation = new ConversationManager(this);
			
			sql = new SQL(this);
			cmd = new CommandListener(this);
			event = new EventListener(this);
			
			getCommand("rpc").setExecutor(cmd);
			
			if(isEnabled()){
				getServer().getPluginManager().registerEvents(event, this);
			}
		}
		
		public void onDisable(){
			try {
				Field byIdField = Enchantment.class.getDeclaredField("byId");
				Field byNameField = Enchantment.class.getDeclaredField("byName");
				 
				byIdField.setAccessible(true);
				byNameField.setAccessible(true);
				 
				@SuppressWarnings("unchecked")
				HashMap<Integer, Enchantment> byId = (HashMap<Integer, Enchantment>) byIdField.get(null);
				@SuppressWarnings("unchecked")
				HashMap<String, Enchantment> byName = (HashMap<String, Enchantment>) byNameField.get(null);
				 
				if(byId.containsKey(255))
				byId.remove(255);
				 
				if(byName.containsKey("Glow"))
				byName.remove("Glow");
			} catch (Exception ignored) { }
			
			try {
				sql.close();
			}catch(Exception ex) { }
		}
		
		
		public void exit(){			
			this.setEnabled(false);
			
			System.out.println(ChatColor.stripColor(prefix + "-----------------------------------------------------"));
			System.out.println(ChatColor.stripColor(prefix + " RolePlayCards was disabled, because of an Exception:"));
			System.out.println(ChatColor.stripColor(prefix + " Contact me if this happens to you all the time."));
			System.out.println(ChatColor.stripColor(prefix + "-----------------------------------------------------"));
		}
		
	}
