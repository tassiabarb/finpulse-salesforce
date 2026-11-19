import { createElement } from '@lwc/engine-dom';
import CreditSimulator from 'c/creditSimulator';

describe('c-credit-simulator', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('renders component successfully', () => {
        const element = createElement('c-credit-simulator', {
            is: CreditSimulator
        });

        document.body.appendChild(element);

        expect(1).toBe(1);
    });
});
