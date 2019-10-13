// import libraries
import React, { Component } from 'react';
import { StyleSheet, View, Text } from 'react-native';

// create a component
class ListsScreen extends Component {
    render() {
        return (
            <View style={styles.container}>
                <Text>ListsScreen</Text>
            </View>
        );
    }
}

// define your styles
const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#2c3e50',
    },
});

// make this component available to the app
export default ListsScreen;
