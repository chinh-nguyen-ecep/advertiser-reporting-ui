package rtb.core;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ConnectionUtils {

	/**
	 * @param args
	 * @throws SQLException 
	 */
	public static ResultSet queryTable(Connection connectionDB,String tableName,String dimensions,String measures,String wheres,String orders,int itemPerPage,int page) throws SQLException{
		ResultSet result=null;
		if(connectionDB!=null){
			String query="SELECT "+dimensions+" , "+measures+" " +
					"FROM " +tableName+" " ;
										
			if(!wheres.equals("")){
				query+=wheres+" ";
			}
			query+="GROUP BY "+dimensions+" ";	
			if(!orders.equals("")){
				query+=orders+" ";
			}
			query+="LIMIT "+itemPerPage+" OFFSET "+(page-1)*itemPerPage;
			System.out.println("Query: "+query);
			long startTime = System.currentTimeMillis();
			PreparedStatement ps=connectionDB.prepareStatement(query);
			result=ps.executeQuery();
			long endTime = System.currentTimeMillis();
			System.out.println("Query: "+query+"; "+(endTime - startTime) + " milliseconds");
		}
		return result;
	}
	public static String getQueryDim(String tableName,String dimensions,String wheres,String orders,int itemPerPage,int page){
		String query="SELECT "+dimensions+" FROM " +tableName+" " ;
									
		if(!wheres.equals("")){
			query+=wheres+" ";
		}
		query+="GROUP BY "+dimensions+" ";	
		if(!orders.equals("")){
			query+=orders+" ";
		}
		query+="LIMIT "+itemPerPage+" OFFSET "+(page-1)*itemPerPage;
		return query;
	}
	public static String getQuery(String tableName,String dimensions,String measures,String wheres,String orders,int itemPerPage,int page){
		String query="SELECT "+dimensions+" , "+measures+" " +
				"FROM " +tableName+" " ;
									
		if(!wheres.equals("")){
			query+=wheres+" ";
		}
		query+="GROUP BY "+dimensions+" ";	
		if(!orders.equals("")){
			query+=orders+" ";
		}
		query+="LIMIT "+itemPerPage+" OFFSET "+(page-1)*itemPerPage;
		return query;
	}
	public static ResultSet queryDimTable(Connection connectionDB,String tableName,String dimensions,String wheres,String orders,int itemPerPage,int page) throws SQLException{
		ResultSet result=null;
		if(connectionDB!=null){
			String query="SELECT "+dimensions+" FROM " +tableName+" " ;
										
			if(!wheres.equals("")){
				query+=wheres+" ";
			}			
			if(!orders.equals("")){
				query+=orders+" ";
			}
			query+="LIMIT "+itemPerPage+" OFFSET "+(page-1)*itemPerPage;
			System.out.println("Query: "+query);
			long startTime = System.currentTimeMillis();
			PreparedStatement ps=connectionDB.prepareStatement(query);
			result=ps.executeQuery();
			long endTime = System.currentTimeMillis();
			System.out.println("Query: "+query+"; "+(endTime - startTime) + " milliseconds");
		}
		return result;
	}
	public static int getTotalPageNumber(Connection connectionDB,String tableName,String dimensions,String measures,String wheres,String orders,int itemPerPage) throws SQLException{
		int result=0;
		if(connectionDB!=null){
			String query="SELECT COUNT(1) " +"FROM " +tableName+" " ;
										
			if(!wheres.equals("")){
				query+=wheres+" ";
			}
			if(!dimensions.equals("")){
				query+="GROUP BY "+dimensions+" ";
			}
			
			query="SELECT COUNT(1) FROM ("+query+") a";
			System.out.println("Query count page number: "+query);
			PreparedStatement ps=connectionDB.prepareStatement(query);
			ResultSet resultSet=ps.executeQuery();
			int totalCount=0;
			while(resultSet.next()){
				totalCount=resultSet.getInt(1);
			}
			
			if(totalCount%itemPerPage>0){
				result=totalCount/itemPerPage+1;
			}else{
				result=totalCount/itemPerPage;
			}
			
		}
		return result;
	}
	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}

}
