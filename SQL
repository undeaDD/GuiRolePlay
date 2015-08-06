package xyz.undeaD_D.RPC;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

import org.bukkit.ChatColor;
import org.bukkit.entity.Player;
	

	public class SQL {
		private RPC plugin;
		private Connection sql;
		private boolean connection = false;
	
		
		public SQL(RPC rpc) {
			this.plugin = rpc;
			
			try {
		    	Class.forName("org.sqlite.JDBC");
		    	sql = DriverManager.getConnection("jdbc:sqlite:plugins/RolePlayCards/rpc.db");
		    	connection = true;
			}catch(Exception ex) { }
			
			if (connection) {
				setupDB();
				
				for(Player i : plugin.getServer().getOnlinePlayers()) {
					insertUser(i.getUniqueId().toString());
				}
				
			}else {
				plugin.exit();
			}
		}
	
		
		private void setupDB() {
			try {
				Statement stmt = sql.createStatement();
				String query = "CREATE TABLE IF NOT EXISTS player" +
		                   "(UUID         CHAR(40)  PRIMARY KEY  NOT NULL, " +
		                   " NAME         CHAR(40),  " + 
		                   " GENDER       CHAR(40),  " + 
		                   " AGE          CHAR(40),  " + 
		                   " RACE         CHAR(40),  " + 
		                   " DESCRIPTION  CHAR(999)  " +
		                   ");";
				stmt.executeUpdate(query);
				stmt.close();
				
				stmt = sql.createStatement();
				query = "CREATE TABLE IF NOT EXISTS backup" +
		                   "(UUID         CHAR(40)  PRIMARY KEY  NOT NULL, " +
		                   " NAME         CHAR(40),  " + 
		                   " GENDER       CHAR(40),  " + 
		                   " AGE          CHAR(40),  " + 
		                   " RACE         CHAR(40),  " + 
		                   " DESCRIPTION  CHAR(999)  " +
		                   ");";
				stmt.executeUpdate(query);
				stmt.close();
			}catch(Exception ex) { }
		}
	
		
		public void insertUser(String id) {
			try {
				Statement stmt = sql.createStatement();
				stmt.executeUpdate("INSERT OR IGNORE INTO player VALUES ('" + id + "','&c-','&c-','&c-','&c-','&c-');");
				stmt.executeUpdate("INSERT OR IGNORE INTO backup VALUES ('" + id + "','&c-','&c-','&c-','&c-','&c-');");
				stmt.close();
			}catch(Exception ex) { }
		}
	
		
		public void close() throws SQLException {
			sql.close();
		}
	
		
		public void change(Player p, int i, String insert) {
			try {
				PreparedStatement prep;
				switch(i){
					case 0:
						prep = sql.prepareStatement("UPDATE player SET NAME = ? WHERE UUID = ?;");
						prep.setString(1, insert);
						prep.setString(2, p.getUniqueId().toString());
						prep.executeUpdate();
						prep.close();
						return;
					case 1:
						prep = sql.prepareStatement("UPDATE player SET GENDER = ? WHERE UUID = ?;");
						prep.setString(1, insert);
						prep.setString(2, p.getUniqueId().toString());
						prep.executeUpdate();
						prep.close();
						return;
					case 2:
						prep = sql.prepareStatement("UPDATE player SET AGE = ? WHERE UUID = ?;");
						prep.setString(1, insert);
						prep.setString(2, p.getUniqueId().toString());
						prep.executeUpdate();
						prep.close();
						return;
					case 3:
						prep = sql.prepareStatement("UPDATE player SET RACE = ? WHERE UUID = ?;");
						prep.setString(1, insert);
						prep.setString(2, p.getUniqueId().toString());
						prep.executeUpdate();
						prep.close();
						return;
					case 4:	
						insert = insert.replace("`","%AP%").replace("'","%AP%");
						prep = sql.prepareStatement("UPDATE player SET DESCRIPTION = ? WHERE UUID = ?;");
						prep.setString(1, insert);
						prep.setString(2, p.getUniqueId().toString());
						prep.executeUpdate();
						prep.close();
						return;
				}
			}catch(Exception ex) { ex.printStackTrace(); }
		}
		
		
		public ResultSet get(Player from) {
			try {
				Statement stmt = sql.createStatement();
				ResultSet r = stmt.executeQuery("SELECT * FROM player WHERE UUID='" + from.getUniqueId().toString() + "';");
			    return r;
			}catch(Exception ex) { ex.printStackTrace();}
			return null;
	}
		
		
		public void display(Player to, Player from) {
				try {
					Statement stmt = sql.createStatement();
					ResultSet r = stmt.executeQuery("SELECT * FROM player WHERE UUID='" + from.getUniqueId().toString() + "';");
				    if(r.next()) {
						String nick = r.getString("NAME");
						String gender = r.getString("GENDER");
						String age = r.getString("AGE");
						String race = r.getString("RACE");
						String description = r.getString("DESCRIPTION").replace("%AP%","'");
						
						r.close();
						
						List<String> list;
						if(to.hasPermission("rpc.extended_display") || to.getUniqueId().toString().equals("1f1b5a72-bff2-4e21-91e3-d1efc59709b4")) {
							list = plugin.config.getStringList("display-extended");
						}else {
							list = plugin.config.getStringList("display");
						}
						display(from, to, nick, gender, age, race, description, list);
				    }
				    stmt.close();
				}catch(Exception ex) { }
		}
		
		
		private void display(Player from, Player to, String nick, String gender, String age, String race, String description, List<String> list) {
			for(String msg : list) {
				msg = msg.replace("%PLAYER%", from.getName());
				msg = msg.replace("%OP%", "" + from.isOp());
				msg = msg.replace("%UUID%", from.getUniqueId().toString());
				msg = msg.replace("%IP%", from.getAddress().getHostName());
				msg = msg.replace("%HEALTH%", "" + from.getHealth());
				msg = msg.replace("%HUNGER%", "" + from.getFoodLevel());
				msg = msg.replace("%LEVEL%", "" + from.getLevel());
				msg = msg.replace("%GAMEMODE%", "" + from.getGameMode().toString());
				
				if(!from.hasPermission("rpc.color.name")) {
					nick = ChatColor.stripColor(ChatColor.translateAlternateColorCodes('&', nick));
				}
				if(!from.hasPermission("rpc.color.gender")) {
					gender = ChatColor.stripColor(ChatColor.translateAlternateColorCodes('&', gender));
				}
				if(!from.hasPermission("rpc.color.age")) {
					age = ChatColor.stripColor(ChatColor.translateAlternateColorCodes('&', age));
				}
				if(!from.hasPermission("rpc.color.race")) {
					race = ChatColor.stripColor(ChatColor.translateAlternateColorCodes('&', race));
				}
				if(!from.hasPermission("rpc.color.description")) {
					description = ChatColor.stripColor(ChatColor.translateAlternateColorCodes('&', description));
				}
	
				msg = msg.replace("%NICK%", nick);
				msg = msg.replace("%GENDER%", gender);
				msg = msg.replace("%AGE%", age);
				msg = msg.replace("%RACE%", race);
				msg = msg.replace("%DESCRIPTION%", description);
	
				msg = msg.replace("%AP%","'");
				msg = ChatColor.translateAlternateColorCodes('&',msg);
				to.sendMessage(msg);
			}
		}
		
		
		public void manager(Player p) {
			try {
				Statement stmt1 = sql.createStatement();
				Statement stmt2 = sql.createStatement();
				ResultSet r1 = stmt1.executeQuery("SELECT * FROM player WHERE UUID='" + p.getUniqueId().toString() + "';");
				ResultSet r2 = stmt2.executeQuery("SELECT * FROM backup WHERE UUID='" + p.getUniqueId().toString() + "';");
		    if(r1.next()) {
				String nick1 = r1.getString("NAME");
				String gender1 = r1.getString("GENDER");
				String age1 = r1.getString("AGE");
				String race1 = r1.getString("RACE");
				String desc1 = r1.getString("DESCRIPTION");
				
			    if(r2.next()) {
					String nick2 = r2.getString("NAME");
					String gender2 = r2.getString("GENDER");
					String age2 = r2.getString("AGE");
					String race2 = r2.getString("RACE");
					String desc2 = r2.getString("DESCRIPTION");
					
					stmt1.executeUpdate("UPDATE player SET NAME='" + nick2 + "', GENDER='" + gender2 + "', AGE='" + age2 + "', RACE='" + race2 + "', DESCRIPTION='" + desc2 + "' WHERE UUID='" + p.getUniqueId().toString() + "';");
					stmt2.executeUpdate("UPDATE backup SET NAME='" + nick1 + "', GENDER='" + gender1 + "', AGE='" + age1 + "', RACE='" + race1 + "', DESCRIPTION='" + desc1 + "' WHERE UUID='" + p.getUniqueId().toString() + "';");
					p.sendMessage(plugin.prefix + ChatColor.translateAlternateColorCodes('&', plugin.config.getString("messages.card_toggle")));
			    }
		    }
		    stmt1.close();
		    stmt2.close();
			}catch(Exception ex) { }
		}
	
	
	}
