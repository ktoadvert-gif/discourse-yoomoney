import { withPluginApi } from 'discourse/lib/plugin-api';
import I18n from 'I18n';
export default {
  name: 'discourse-yoomoney',
  initialize() {
    withPluginApi('0.8.31', api => {
      const siteSettings = api.container.lookup('site-settings:main');
      if (!siteSettings.yoomoney_enabled) return;
      api.decorateWidget('header-buttons:before', helper => {
        return helper.attach('header-dropdown', {
          title: 'yoomoney.button_text',
          icon: 'credit-card',
          action: () => {
            const userId = api.getCurrentUser().id;
            const walletId = siteSettings.yoomoney_wallet_id;
            const amount = siteSettings.yoomoney_payment_amount;
            const url = 'https://yoomoney.ru/quickpay/confirm.xml?' +
              'receiver=' + walletId +
              '&quickpay-form=button' +
              '&targets=' + encodeURIComponent(I18n.t('js.yoomoney.title')) +
              '&paymentType=PC' +
              '&sum=' + amount +
              '&label=' + userId;
            window.open(url, '_blank');
          }
        });
      });
    });
  }
};