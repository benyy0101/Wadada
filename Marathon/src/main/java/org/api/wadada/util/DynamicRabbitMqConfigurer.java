package org.api.wadada.util;

import lombok.AllArgsConstructor;
import org.api.wadada.config.RabbitMQConfig;
import org.springframework.amqp.core.Binding;
import org.springframework.amqp.core.BindingBuilder;
import org.springframework.amqp.core.DirectExchange;
import org.springframework.amqp.core.Queue;
import org.springframework.amqp.rabbit.core.RabbitAdmin;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
@AllArgsConstructor
public class DynamicRabbitMqConfigurer {

    private final RabbitAdmin rabbitAdmin;
    private final RabbitMQConfig rabbitMQConfig;
//    public void createQueueAndBindToExchange(String queueName, String exchangeName, String routingKey) {
//        // Queue 생성
//        Queue queue = new Queue(queueName, true); // durable: true
//        rabbitAdmin.declareQueue(queue);
//
//        // 이미 생성된 Exchange에 대한 참조가 필요한 경우 아래와 같이 선언할 수 있습니다.
//        // 이 예제에서는 DirectExchange를 사용합니다만, 필요에 따라 다른 타입(Topic, Fanout 등)으로 변경 가능합니다.
//        DirectExchange exchange = new DirectExchange(exchangeName);
//        rabbitAdmin.declareExchange(exchange);
//
//
//        // Queue와 Exchange를 RoutingKey를 사용하여 바인딩
//        Binding binding = BindingBuilder.bind(queue).to(exchange).with(routingKey);
//        rabbitAdmin.declareBinding(binding);
//    }
    public void bindExistingQueueToExchange(String queueName, String exchangeName, String routingKey) {
        // 이미 존재하는 Queue와 Exchange에 대한 참조를 얻기 위해 이름만 사용합니다.
        // Queue의 생성을 시도하지 않고, 직접적으로 Queue 객체를 생성하는 대신 이름을 이용합니다.

        // 이미 생성된 Exchange에 대한 참조를 얻습니다.
        // 이 예제에서는 DirectExchange를 사용합니다만, 필요에 따라 다른 타입으로 변경 가능합니다.
        DirectExchange exchange = new DirectExchange(exchangeName);
        rabbitAdmin.declareExchange(exchange); // Exchange가 이미 존재하지 않는 경우를 위해 선언

        // Queue와 Exchange를 RoutingKey를 사용하여 바인딩합니다.
        // 여기서는 Queue 객체 대신 Queue의 이름을 사용하여 바인딩을 생성합니다.
        Binding binding = BindingBuilder.bind(new Queue(queueName)).to(exchange).with(routingKey);
        rabbitAdmin.declareBinding(binding);
    }

    public void removeBinding(String queueName, String exchangeName, String routingKey) {
        // DirectExchange 객체 생성. 실제 상황에 맞춰서 다른 타입의 Exchange를 사용할 수도 있습니다.
        DirectExchange exchange = new DirectExchange(exchangeName);

        // Binding 객체 생성
        Binding binding = BindingBuilder.bind((rabbitMQConfig.queue())).to(exchange).with(routingKey);

        // 바인딩 제거
        rabbitAdmin.removeBinding(binding);
    }

    public boolean checkBindingExists(String queueName, String exchangeName, String routingKey) {
        DirectExchange exchange = new DirectExchange(exchangeName);
        Queue queue = new Queue(queueName);
        Binding binding = BindingBuilder.bind(queue).to(exchange).with(routingKey);

        try {
            // 바인딩을 선언합니다. 이 바인딩이 이미 존재한다면, RabbitMQ는 아무런 동작을 하지 않습니다.
            rabbitAdmin.declareBinding(binding);

            // 성공적으로 선언되었거나 이미 존재하는 경우, 바인딩이 존재한다고 가정합니다.
            return true;
        } catch (Exception e) {
            // 바인딩 선언 중 예외가 발생한 경우, 바인딩 존재 여부를 확인하는데 실패했음을 의미합니다.
            // 실제 애플리케이션에서는 예외 처리 로직을 추가해야 합니다.
            return false;
        }
    }
    public void deleteQueue(String queueName) {
        rabbitAdmin.deleteQueue(queueName);
    }
}