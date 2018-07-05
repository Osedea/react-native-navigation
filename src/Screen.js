/*eslint-disable*/
import React, {Component} from 'react';
import {
  NativeAppEventEmitter,
  DeviceEventEmitter,
  Platform
} from 'react-native';
import platformSpecific from './deprecated/platformSpecificDeprecated';
import Navigation from './Navigation';

const NavigationSpecific = {
  push: platformSpecific.navigatorPush,
  pop: platformSpecific.navigatorPop,
  popToRoot: platformSpecific.navigatorPopToRoot,
  resetTo: platformSpecific.navigatorResetTo
};

class Navigator {
  constructor(navigatorID, navigatorEventID, screenInstanceID) {
    this.navigatorID = navigatorID;
    this.screenInstanceID = screenInstanceID;
    this.navigatorEventID = navigatorEventID;
    this.navigatorEventHandler = null;
    this.navigatorEventHandlers = [];
    this.navigatorEventSubscription = null;
  }

  push(params = {}) {
    return NavigationSpecific.push(this, params);
  }

  pop(params = {}) {
    return NavigationSpecific.pop(this, params);
  }

  popToRoot(params = {}) {
    return NavigationSpecific.popToRoot(this, params);
  }

  resetTo(params = {}) {
    return NavigationSpecific.resetTo(this, params);
  }

  showModal(params = {}) {
    return Navigation.showModal(params);
  }

  showLightBox(params = {}) {
    return Navigation.showLightBox(params);
  }

  dismissModal(params = {}) {
    return Navigation.dismissModal(params);
  }

  dismissAllModals(params = {}) {
    return Navigation.dismissAllModals(params);
  }

  showLightBox(params = {}) {
    return Navigation.showLightBox(params);
  }

  dismissLightBox() {
    return Navigation.dismissLightBox();
  }

  showInAppNotification(params = {}) {
    return Navigation.showInAppNotification(params);
  }

  dismissInAppNotification(params = {}) {
    return Navigation.dismissInAppNotification(params);
  }

  setButtons(params = {}) {
    return platformSpecific.navigatorSetButtons(this, this.navigatorEventID, params);
  }

  setTitle(params = {}) {
    return platformSpecific.navigatorSetTitle(this, params);
  }

  setSubTitle(params = {}) {
    return platformSpecific.navigatorSetSubtitle(this, params);
  }

  setTitleImage(params = {}) {
    return platformSpecific.navigatorSetTitleImage(this, params);
  }

  setStyle(params = {}) {
    return platformSpecific.navigatorSetStyle(this, params);
  }

  toggleDrawer(params = {}) {
    return platformSpecific.navigatorToggleDrawer(this, params);
  }

  setDrawerEnabled(params = {}) {
    return platformSpecific.navigatorSetDrawerEnabled(this, params);
  }

  toggleTabs(params = {}) {
    return platformSpecific.navigatorToggleTabs(this, params);
  }

  toggleNavBar(params = {}) {
    return platformSpecific.navigatorToggleNavBar(this, params);
  }

  setTabBadge(params = {}) {
    return platformSpecific.navigatorSetTabBadge(this, params);
  }

  setTabButton(params = {}) {
    return platformSpecific.navigatorSetTabButton(this, params);
  }

  switchToTab(params = {}) {
    return platformSpecific.navigatorSwitchToTab(this, params);
  }

  switchToTopTab(params = {}) {
    return platformSpecific.navigatorSwitchToTopTab(this, params);
  }

  showSnackbar(params = {}) {
    return platformSpecific.showSnackbar(params);
  }

  dismissSnackbar() {
    return platformSpecific.dismissSnackbar();
  }

  showContextualMenu(params, onButtonPressed) {
    return platformSpecific.showContextualMenu(this, params, onButtonPressed);
  }

  dismissContextualMenu() {
    return platformSpecific.dismissContextualMenu();
  }

  setOnNavigatorEvent(callback) {
    if (this.navigatorEventHandlers.length > 0) {
      throw new Error('setOnNavigatorEvent can not be used after addOnNavigatorEvent has been called');
    }
    this.navigatorEventHandler = callback;
    this._registerNavigatorEvent();
  }

  addOnNavigatorEvent(callback) {
    if (this.navigatorEventHandler) {
      throw new Error('addOnNavigatorEvent can not be used after setOnNavigatorEvent has been called');
    }
    if (this.navigatorEventHandlers.indexOf(callback) === -1) {
      this.navigatorEventHandlers.push(callback);
    }
    this._registerNavigatorEvent();

    return () => this._removeOnNavigatorEvent(callback)
    
  }

  _registerNavigatorEvent() {
    if (!this.navigatorEventSubscription) {
      let Emitter = Platform.OS === 'android' ? DeviceEventEmitter : NativeAppEventEmitter;
      this.navigatorEventSubscription = Emitter.addListener(this.navigatorEventID, (event) => this.onNavigatorEvent(event));
      Navigation.setEventHandler(this.navigatorEventID, (event) => this.onNavigatorEvent(event));
    }
  }

  _removeOnNavigatorEvent(callback) {
    const index = this.navigatorEventHandlers.indexOf(callback);
    if (index !== -1) {
      this.navigatorEventHandlers.splice(index, 1);
    }
  }

  onNavigatorEvent(event) {
    if (this.navigatorEventHandler) {
      this.navigatorEventHandler(event);
    }
    this.navigatorEventHandlers.forEach(handler => handler(event));
  }

  handleDeepLink(params = {}) {
    Navigation.handleDeepLink(params);
  }

  cleanup() {
    if (this.navigatorEventSubscription) {
      this.navigatorEventSubscription.remove();
      this.navigatorEventHandlers = [];
      Navigation.clearEventHandler(this.navigatorEventID);
    }
  }

  async screenIsCurrentlyVisible() {
    const res = await Navigation.getCurrentlyVisibleScreenId();
    if (!res) {
      return false;
    }
    return res.screenId === this.screenInstanceID;
  }

  showOverlay() {
    return platformSpecific.showOverlay();
  }

  dismissOverlay() {
    return platformSpecific.dismissOverlay();
  }
}

class Screen extends Component {
  static navigatorStyle = {};
  static navigatorButtons = {};

  constructor(props) {
    super(props);
    if (props.navigatorID) {
      this.navigator = new Navigator(props.navigatorID, props.navigatorEventID, props.screenInstanceID);
    }
  }

  componentWillUnmount() {
    if (this.navigator) {
      this.navigator.cleanup();
      this.navigator = undefined;
    }
  }
}

export {
  Screen,
  Navigator
};
