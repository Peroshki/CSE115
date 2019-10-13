// import libraries
import React from 'react';
import { createAppContainer } from 'react-navigation';
import { createBottomTabNavigator } from 'react-navigation-tabs';
import Icon from "react-native-vector-icons/FontAwesome";
import ListsScreen from './ListsScreen.js';
import ProfileScreen from './ProfileScreen.js'
import SettingsScreen from './SettingsScreen.js'

const tabNavigator = createBottomTabNavigator(
    {
        Lists: {
            screen: ListsScreen,
            navigationOptions: {
                tabBarIcon: ({ tintColor }) => (
                    <Icon name="list" size={25} color={tintColor}/>
                )
            }
        },
        Profile: {
            screen: ProfileScreen,
            navigationOptions: {
                tabBarIcon: ({ tintColor }) => (
                    <Icon name="user" size={25} color={tintColor}/>
                )
            }
        },
        Settings: {
            screen: SettingsScreen,
            navigationOptions: {
                tabBarIcon: ({ tintColor }) => (
                    <Icon name="gear" size={25} color={tintColor}/>
                )
            }   
        }
    },
    {
        initialRouteName: 'Lists',
        tabBarOptions: {
            activeTintColor: '#eb6e3d'
        }
    }
);

// make this component available to the app
export default createAppContainer(tabNavigator);
