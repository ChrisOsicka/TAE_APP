import { StatusBar } from "expo-status-bar";
import { StyleSheet, View, Text, Button, Image } from "react-native";
import React from "react";

export default function HomeScreen() {
  return (
    <View style={styles.container}>

    <View style={styles.imagen}>
    <Image source={require("../../assets/images/logo.png")}/>
    </View>
    <Text style={styles.title}>Bienvenido a TaeApp</Text>
    <View style={styles.button1}>
    <Button title="Iniciar Sesion"onPress={() => console.log("Boton de Iniciar Sesion Presionado")} color="#FF5733"/>
    </View>
    <View style={styles.button2}>
    <Button title="Registrarse"onPress={() => console.log("Boton de Registrarse Presionado")}/>
    </View>

    </View>
  );
}


const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: "center", // Centra verticalmente
    alignItems: "center", // Centra horizontalmente
    backgroundColor: "#f5f5f5", // Color de fondo opcional
  },
  title: {
    fontSize: 35, // Tamaño grande del texto
    fontWeight: "bold", // Negrita
    textAlign: "center", // Asegura que el texto esté centrado
    color: "#333", // Color del texto
    paddingHorizontal: 20, // Espaciado en los lados
  },
  button1:{
    width: "40%",
    position: "absolute", // Ubicación exacta
    left: 20, // Alinea a la izquierda
    top: 450, // Lo baja 100 píxeles desde arriba
  },
  button2:{
    width: "40%",
    position: "absolute", // Ubicación exacta
    right: 20, // Alinea a la izquierda
    top: 450, // Lo baja 100 píxeles desde arriba

  },
  imagen:{
    width: 100,  // Ancho de la imagen
    height: 100, // Alto de la imagen
    position: "absolute", //Ubicación
    top: 140,
    left: 100, 
    resizeMode: "contain", // Ajusta la imagen sin distorsión
  }
});

