import React from "react";
import { View, StyleSheet, Image, Button } from "react-native";
import { arModule } from "../native/arModule";

export const styles = StyleSheet.create({
  container: {
    position: "absolute",
    left: 0,
    right: 0,
    top: 0,
    bottom: 0,
    width: "100%",
    height: "100%",
    justifyContent: "center",
    alignItems: "center",
    backgroundColor: "white",
    flex: 1,
  },
  logo: {
    marginBottom: 20,
  },
});

export const App = () => {
  const handleClick = () => {
    arModule.show();
  };

  return (
    <View style={styles.container}>
      <Image style={styles.logo} source={require("../assets/logo.png")} />
      <Button onPress={handleClick} title="Go to AR" color="#8645EA" />
    </View>
  );
};
