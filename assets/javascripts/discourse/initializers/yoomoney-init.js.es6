import { withPluginApi } from 'discourse/lib/plugin-api';
import I18n from 'I18n';
export default {
  name: 'discourse-yoomoney',
  initialize() {
    withPluginApi('0.8.31', api => {
      console.log('discourse-yoomoney: plugin initialized');
      // Widget decoration removed in favor of Glimmer components and connectors
    });
  }
};