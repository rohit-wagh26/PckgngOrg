import { LightningElement ,api} from 'lwc';
import home  from './home.html';
import settings from './settings.html' ; 
import administration from './administration.html' ;

const PAGE_ID_TO_TEMPLATE = {
    
        home,
        settings,
        administration,
   };

export default class FmPages extends LightningElement {
    @api currentPageId;
    
    render() {
        return PAGE_ID_TO_TEMPLATE[this.currentPageId];
    }
}