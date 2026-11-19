public with sharing class ViaCepService {
    public static Map<String, Object> getAddressByCep(String cep) {
        String cleanCep = cep.replaceAll('[^0-9]', '');
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://viacep.com.br/ws/' + cleanCep + '/json/');
        req.setMethod('GET');
        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() == 200) {
            return (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        }

        return null;
    }
}
