package xyz.undeaD_D.RPC;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;

import org.bukkit.ChatColor;
import org.bukkit.entity.Player;
import org.bukkit.event.EventHandler;
import org.bukkit.event.Listener;
import org.bukkit.event.player.PlayerJoinEvent;


	public class Updater implements Listener{
		private boolean update = false;
		private RPC plugin;
				
		
		public Updater(RPC plugin) {
			this.plugin = plugin;
			plugin.getServer().getPluginManager().registerEvents(this, plugin);
			
			String sourceLine = null;
	        try {
		        URL url = new URL("http://pokemon-online.xyz/plugin/version.php");
		        BufferedReader in = new BufferedReader(new InputStreamReader(url.openStream()));
		        String str;
		        while ((str = in.readLine()) != null) {
		            if(str.startsWith("GUIrpc:")) {
		            	sourceLine = str.split(":")[1];
		            	break;
		            }
		        }
	        } catch (Exception ex) {ex.printStackTrace();}
	        
		    if(sourceLine != null && Integer.parseInt(sourceLine) > Integer.parseInt(plugin.getDescription().getVersion())){
		    	update  = true;
		    	say(null, true);
		    	
			    for (Player p : plugin.getServer().getOnlinePlayers()) {
			    	if(p.isOp() || p.hasPermission("rpc.update")) {
			    		say(p, false);
			    	}
			    }
		    }
		}
	
		
		@EventHandler
		public void login(PlayerJoinEvent e) {
			if(update) {
		    	if(e.getPlayer().isOp() || e.getPlayer().hasPermission("rpc.update")) {
		    		say(e.getPlayer(), false);
		    	}
			}
		}
		
		
		private void say(Player p, boolean b) {
			String prefix = ChatColor.translateAlternateColorCodes('&', plugin.config.getString("messages.prefix"));
			if(b) {
				System.out.println(ChatColor.stripColor(prefix + "-----------------------------------------------------"));
				System.out.println(ChatColor.stripColor(prefix + " RolePlayCards is outdated. Get the new version here:"));
				System.out.println(ChatColor.stripColor(prefix + " http://www.pokemon-online.xyz/plugin"));
				System.out.println(ChatColor.stripColor(prefix + "-----------------------------------------------------"));
			}else {
			   	p.sendMessage(prefix + "-----------------------------------------------");
			   	p.sendMessage(prefix + " RolePlayCards is outdated. Get the new version here:");
			   	p.sendMessage(prefix + " http://www.pokemon-online.xyz/plugin");
			   	p.sendMessage(prefix + "-----------------------------------------------");
			}
		}
	
	
	}
