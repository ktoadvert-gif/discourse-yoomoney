import Component from "@glimmer/component";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";
import I18n from "I18n";

export default class YoomoneyButton extends Component {
    @service siteSettings;
    @service currentUser;

    @action
    pay() {
        if (!this.currentUser) {
            return;
        }

        const userId = this.currentUser.id;
        const walletId = this.siteSettings.yoomoney_wallet_id;
        const amount = this.siteSettings.yoomoney_payment_amount;

        const url = 'https://yoomoney.ru/quickpay/confirm.xml?' +
            'receiver=' + walletId +
            '&quickpay-form=button' +
            '&targets=' + encodeURIComponent(I18n.t('js.yoomoney.title')) +
            '&paymentType=PC' +
            '&sum=' + amount +
            '&label=' + userId;

        window.open(url, '_blank');
    }
}
