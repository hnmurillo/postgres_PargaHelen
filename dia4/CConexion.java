
import java.sql.Connection;
import java.sql.DriverManager;
import javax.swing.JOptionPane;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author camper
 */
public class CConexion {
     Connection conectar = null;
     
     String usuario= "postgres";
     String contraseña = "1001301103";
     String bd = "campuscars";
     String ip="172.16.101.153";
     String puerto = "5432";
             
     String cadena = "jdbc:postgresql://"+ip+":"+ puerto+"/"+bd;
     public Connection  establecerConexion(){
         
         try {
             Class.forName("org.postgresql.Driver");
              conectar = DriverManager.getConnection(cadena, usuario, contraseña);
              JOptionPane.showMessageDialog(null,"Se conecto correctamente");   
         }catch (Exception e){
             JOptionPane.showMessageDialog(null,"Error al conectar"+ e.toString());
         }
         
         return conectar;
     }
     
     
}
