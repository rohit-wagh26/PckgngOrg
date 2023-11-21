@isTest
public class FunnelMultiselectControllerTest {
    static testmethod void testSelector(){
        FunnelMultiselectController ms = new FunnelMultiselectController();
        SelectOption[] ls = ms.leftOptions;
        SelectOption[] rs = ms.rightOptions;
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption ('All','All'));
        options.add(new SelectOption ('Abc','Abc'));
        options.add(new SelectOption ('Def','Def'));
        options.add(new SelectOption ('Xyz','Xyz'));
        String leftHiddn = ms.leftOptionsHidden;
        String rightHiddn = ms.rightOptionsHidden;
        system.assertEquals(options.size(), 4);
    }
}